require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Shhh::Commands::Import do

  before do
    create_home_directory

    @original_path = File.join(home_path, '.test')
    @destination_path = File.join(dotfiles_path, 'test')
  end

  after do
    cleanup_home_directory
    cleanup_dotfiles_directory
    cleanup_editor_responses
  end

  it "creates a .dotfiles directory if it doesn't exist" do
    create_trackable_file(@original_path)

    run_command("import #{@original_path}") do |c|
      c.response(/create one now?/, 'create')
    end

    output_must_contain(/Creating/)
    output_must_contain(/Initialized/)
    directory_must_exist(dotfiles_path)

    directory_must_exist(File.join(dotfiles_path, '.git'))
  end

  it "does not create a .dotfiles directory when a users cancels" do
    create_trackable_file(@original_path)

    run_command("import #{@original_path}", 255) do |c|
      c.response(/create one now?/, 'abort')
    end

    output_must_not_contain(/Creating/)
    output_must_not_contain(/Initializing/)
    directory_must_not_exist(dotfiles_path)
  end

  describe "with an existing dotfiles directory" do

    before do
      create_dotfiles_directory
      create_git_repo
    end

    after do
      cleanup_dotfiles_directory
    end

    it "does not import a nonexistent dotfile" do
      run_command("import .test", 255)
      output_must_contain(/does not exist/)
    end

    it "imports a dotfile" do
      create_trackable_file(@original_path)

      run_command("import #{@original_path}")

      output_must_contain(/Importing/, /Moving/)
      file_must_have_moved(@original_path, @destination_path)
      symlink_must_exist(@original_path, @destination_path)
    end

    it "imports a classified dotfile" do
      dynamic_path = File.join(dotfiles_path, 'test.classified')
      create_file @original_path, <<-TEXT
setting: ABCDEFG
TEXT

      stub_editor_response dynamic_path, <<-TEXT
# Edit the file below, replacing and sensitive information to turn this:
#
#   password: superSecretPassword
#
# Into:
#
#   password: # shhh(password)
#
########################################################################
setting: # shhh(token)
TEXT

      run_command("redact #{@original_path}")

      output_must_contain(/Importing/, /Moving/, /Creating classified version at/, /Storing secret value for key: token/)
      secret_must_be_stored('test', 'token', 'ABCDEFG')
      symlink_must_exist(@original_path, @destination_path)
      file_must_not_match(dynamic_path, 'replacing and sensitive information')
      git_ignore_must_include(@destination_path)
    end

    describe "collision handling" do

      before do
        @relocated_path = File.join(dotfiles_path, 'test.old.1')
        create_trackable_file(@original_path)
        create_trackable_file(@destination_path)
      end

      it "renames an existing dotfile when importing a duplicate and instructed to replace it" do
        run_command("import #{@original_path}") do |c|
          c.response(/Do you want to replace it\?/, 'replace')
        end

        output_must_contain(/Moving/, /Symlinking/, /already exists as a dotfile/)
        file_must_exist(@destination_path)
        file_must_exist(@relocated_path)
        symlink_must_exist(@original_path, @destination_path)
      end

      it "renames an existing duplicate dotfile when importing a duplicate and instructed to replace it" do
        duplicate_path = File.join(dotfiles_path, 'test.old.2')
        create_trackable_file(@relocated_path)

        run_command("import #{@original_path}") do |c|
          c.response(/Do you want to replace it\?/, 'replace')
        end

        file_must_have_moved(@destination_path, duplicate_path)
        file_must_not_have_moved(@relocated_path)
      end

      it "does not modify an existing dotfile when instructed not to" do
        run_command("import #{@original_path}", 255) do |c|
          c.response(/Do you want to replace it\?/, 'abort')
        end

        output_must_contain(/already exists as a dotfile/)
        output_must_not_contain(/Moving/, /Symlinking/)
        file_must_not_have_moved(@original_path)
        file_must_not_have_moved(@destination_path)
        file_must_not_exist(@relocated_path)
        symlink_must_not_exist(@original_path)
      end

    end

  end
end
