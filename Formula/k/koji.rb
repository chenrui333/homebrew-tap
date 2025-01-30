class Koji < Formula
  desc "Interactive CLI for creating conventional commits"
  homepage "https://github.com/cococonscious/koji"
  url "https://github.com/cococonscious/koji/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "648b9d47de121895a79e3d963f5fc6e781d82a1531eeec6b3aa91db5951e058a"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"koji", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/koji --version")

    require "pty"
    ENV["TERM"] = "xterm"

    # setup git
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"

    # commit with koji
    # $ /opt/homebrew/Cellar/koji/3.2.0/bin/koji
    # > What type of change are you committing? feat
    # > What's the scope of this change? test
    # > Write a short, imperative tense description of the change: test
    # > Provide a longer description of the change: test
    # > Are there any breaking changes? No
    # > Does this change affect any open issues? No
    PTY.spawn(bin/"koji") do |r, w, _pid|
      w.puts "feat"
      w.puts "test"
      w.puts "test"
      w.puts "test"
      w.puts "No"
      w.puts "No"
      begin
        output = r.read
        assert_match "Does this change affect any open issues", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
