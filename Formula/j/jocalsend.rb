class Jocalsend < Formula
  desc "Rust terminal client for Localsend"
  homepage "https://git.kittencollective.com/nebkor/joecalsend"
  url "https://static.crates.io/crates/jocalsend/jocalsend-1.6.180339887.crate"
  sha256 "68d6873338af44ae4fd6437a77e46837d84fa45d771ffbb989329c15a770a8f7"
  # https://git.kittencollective.com/nebkor/joecalsend/src/branch/main/LICENSE.md
  # dual license
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28814256eedf5508efbacb803dd46e4fb22da88a8546b4a3add69a39c26df790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5393bad5511b20ca74c930008c61d35a5ee98c41b196ae84ef9e4d2bd55d74fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd2efcc390f1bc325df4490b12879d288e181b809439b1dcc81816d161e10880"
    sha256 cellar: :any,                 arm64_linux:   "3c01e1dc2bae3d86758476ee4f312f82012ce074f4da55227886a33f037510b7"
    sha256 cellar: :any,                 x86_64_linux:  "c7da024421effcaf420064a400767641728a8486b116c6ae8d9d897f3b759aad"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jocalsend --version")

    # Skip linux CI test
    # `Error: IOError(Os { code: 2, kind: NotFound, message: \"No such file or directory\" })`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jocalsend", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Incoming Transfer Requests", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
