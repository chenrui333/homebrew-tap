class Drft < Formula
  desc "Diff re/viewer, file tree"
  homepage "https://codeberg.org/nightsail/drft"
  url "https://codeberg.org/nightsail/drft/archive/0.1.1.tar.gz"
  sha256 "c5be1a8e24929a03767f9bb5475371fd2a9293ae96f86f23b1e3f8098b6f8307"
  license "BSD-3-Clause"
  head "https://codeberg.org/nightsail/drft.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d10f0615f746c0fc5f24f74d9ca454089484ce0c626b088bd25189014bf52da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b47259a6975620c95bee7a5c1f309d814099de0b8a4947dbb572c6b69905fbeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe08b3cbbd71a5c5a1f38254792ddb2509556b2d0d72605df6f9e1282f449a6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4db4a126bc2e4e1ac6ff9771c77560c1355e764cc8e006cf41b0d33065c62dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "911504535245190924a4886c6c27ba75810a4765e5e8d5bf5ae113fae25e3d4e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # failed with Linux CI, `code: 6, kind: Uncategorized, message: \"No such device or address\"`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      (testpath/"diff.patch").write <<~EOS
        --- a/file.txt
        +++ b/file.txt
        @@ -1 +1 @@
        -Hello, world!
        +Hello, Homebrew!
      EOS

      output_log = testpath/"output.log"
      pid = spawn bin/"drft", "diff.patch", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "+Hello, Homebrew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
