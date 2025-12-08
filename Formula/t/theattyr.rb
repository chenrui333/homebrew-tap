class Theattyr < Formula
  desc "Terminal theater for playing VT100 art and animations"
  homepage "https://github.com/orhun/theattyr"
  url "https://github.com/orhun/theattyr/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "c21e6051ddaa2640b864f4ece25578bc6d4c8c8d264fb17c0216a54043caa92a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/orhun/theattyr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b45cf2ac5978d3eb08315393325326d43dab979778ea6eccbb8815176b548f93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48388500eb70369eebac8b7a6ba4cbbe81ea7373bbe3f1693e6a7ec726a4ec1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "738df5b5299bf2ad9e428cb833eb71890667681f70eefe3b540db3898e987033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecf359995ad7fe92dedb9af69bbe5b6b3a9afd227ed206eac26e7a3a72bb790f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d85493970673888291ea0741d611ff28917f918948e268249ce079b763387d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/theattyr --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"theattyr", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "VT100 Animations", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
