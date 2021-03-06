# frozen_string_literal: true

require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  if system_has_zsh?
    install_oh_my_zsh
    switch_to_zsh
  end

  CopyDotFiles.new.run
end

def system_has_zsh?
  system('which zsh')
end

def install_oh_my_zsh
  if File.exist? dest_path('.oh-my-zsh')
    puts 'found ~/.oh-my-zsh'
  else
    ask_install_ohmyzsh
  end
end

OHMYZSH_REPO = 'https://github.com/robbyrussell/oh-my-zsh.git'

def ask_install_ohmyzsh
  print 'install oh-my-zsh? [ynq] '
  case $stdin.gets.chomp
  when 'y'
    puts 'installing oh-my-zsh'
    system %(git clone #{OHMYZSH_REPO} "$HOME/.oh-my-zsh")
    install_zsh_autosuggestions
  when 'q'
    exit
  else
    puts 'skipping oh-my-zsh, you will need to change ~/.zshrc'
  end
end

AUTOSUG_REPO = 'https://github.com/zsh-users/zsh-autosuggestions'

def install_zsh_autosuggestions
  system %(git clone #{AUTOSUG_REPO} $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions)
end

def switch_to_zsh
  if ENV['SHELL'] =~ /zsh/
    puts 'using zsh'
  else
    ask_switch_shell
  end
end

def ask_switch_shell
  print 'switch to zsh? (recommended) [ynq] '
  case $stdin.gets.chomp
  when 'y'
    puts 'switching to zsh'
    system %(chsh -s `which zsh`)
  when 'q'
    exit
  else
    puts 'skipping zsh'
  end
end

# Copy dotfiles to user's home directory
class CopyDotFiles
  attr_reader :replace_all

  FILES = Rake::FileList["*", "config/*/*"] - ['config']
  FILES_OVERWRITE = %w[zshrc bashrc].freeze
  FILES_DO_NOT_COPY = %w[Rakefile README.rdoc LICENSE oh-my-zsh].freeze

  def run
    puts files_need_copy
    files_need_copy.each { |f| copy_file(f) }
  end

  def files_need_copy
    FILES - FILES_DO_NOT_COPY
  end

  private

  def copy_file(file)
    make_dir_for_file(file)

    dest = dest_path(file)

    if FILES_OVERWRITE.include? file
      puts "Coping #{dest_path_for_human(file)}"
      system %(cat "$PWD/#{file}" >> "#{dest}")
    elsif File.exist?(dest)
      handle_exist_file(file)
    else
      link_file(file)
    end
  end

  def make_dir_for_file(file)
    system %(mkdir -p "$HOME/.#{File.dirname(file)}") if file =~ %r{/}
  end

  def handle_exist_file(file)
    if File.identical? file, dest_path(file)
      puts "identical #{dest_path_for_human(file)}"
    elsif replace_all
      replace_file(file)
    else
      print "overwrite #{dest_path_for_human(file)}? [ynaq] "
      ask_replace(file)
    end
  end

  def ask_replace(file)
    case $stdin.gets.chomp
    when 'a'
      @replace_all = true && replace_file(file)
    when 'y'
      replace_file(file)
    when 'q'
      exit
    else
      puts "skipping #{dest_path_for_human(file)}"
    end
  end

  def replace_file(file)
    system %(rm -rf "$HOME/.#{file.sub(/\.erb$/, '')}")
    link_file(file)
  end

  def link_file(file)
    if file =~ /.erb$/
      puts "generating #{dest_path_for_human(file)}"
      File.open(dest_path(file), 'w') do |new_file|
        new_file.write ERB.new(File.read(file)).result(binding)
      end
    else
      puts "linking ~/.#{file}"
      system %(ln -s "$PWD/#{file}" "$HOME/.#{file}")
    end
  end
end

def dest_path(file)
  File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}")
end

def dest_path_for_human(file)
  "~/.#{file.sub(/\.erb$/, '')}"
end
