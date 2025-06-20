class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://github.com/brycx/checkpwn/archive/refs/tags/0.5.4.tar.gz"
  sha256 "f7802910b93932587b8a73aec3b33db24fd8088615a0be89b7c0945500059aae"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/checkpwn acc test@example.com 2>&1", 101)
    assert_match "Failed to read or parse the configuration file 'checkpwn.yml'", output
  end
end
