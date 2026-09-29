class Drft < Formula
  desc "Diff re/viewer, file tree"
  homepage "https://codeberg.org/nightsail/drft"
  url "https://codeberg.org/nightsail/drft/archive/696ab5b76d7eb803cb467abf0b5ccfc5d984df8b73f8b0e7b408258ee2828c62.tar.gz"
  version "1.1.0"
  sha256 "b8af93b9a4043e61d85fd7f4d20ba6fa9f7839c82ad4da41a830da99eeb45082"
  license "BSD-3-Clause"
  head "https://codeberg.org/nightsail/drft.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "055806d388887a57a8bd35e1bcb5a014d58e8dce23c249923c9c649f7918d107"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "472c9f7fa5850244f2a5338934cef20c0267f9efe37ccbfb9267da4ad4e690c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9991c950d0717883de61e6cbe4398af31f7ce3e6b720d61a937dfbe94ba2fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "933bda2b20e28ad36c5f4b392a60e1971abbc1ace5b8d8ff74ac205bf24f449c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae6f8df69548dafe2d3da11c15edc45bcd3fb8c7cbe32937c35b5e8715a0474d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The release lockfile requires an update with current Cargo.
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
