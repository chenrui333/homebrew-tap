class Judo < Formula
  desc "Multi-database TUI for ToDo lists"
  homepage "https://github.com/giacomopiccinini/judo"
  url "https://static.crates.io/crates/judo/judo-1.2.0.crate"
  sha256 "dd1025aca46fcb6bf3d6224d883f3dd47066e9193a9ac4e03fde95d9964d191e"
  license "MIT"
  head "https://github.com/giacomopiccinini/judo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53de8b2988e3233964f420e08cc2f72a917971996b579e5a6da7c89c26ac6bbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948668d544b8a169530f859421e8d09232791d03c45bc55ecb99280703696b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0ceccab88b83a0b6e52e69fa5ce19624d271b06eacbc61737346305f9bf60e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "920b8138ad4b6b12b912f15a4bd096f79be0e788522fcdc0ac02715a4dc592e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0522b4fe0306e79cedfac38898d6b5666a9cc0b7f1b4cc752cf6d5543835b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"judo", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "D A T A B A S E", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
