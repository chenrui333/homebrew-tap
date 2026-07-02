class PassCli < Formula
  desc "Secure CLI password manager with local encrypted storage"
  homepage "https://github.com/ari1110/pass-cli"
  url "https://github.com/ari1110/pass-cli/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "b52325e56cce83eaf4fea951272037a63ac6c5fc33ad0ad18538cd383ff3f224"
  license "Apache-2.0"
  head "https://github.com/ari1110/pass-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28964caec8592c905e74c6463c94b6f76d5b37694d773a9e1273519d7f9c0104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28964caec8592c905e74c6463c94b6f76d5b37694d773a9e1273519d7f9c0104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28964caec8592c905e74c6463c94b6f76d5b37694d773a9e1273519d7f9c0104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f1f95e1821cc8972ac93adf69fd327630aa98f6a4791777f3ccde3d8057e31"
    sha256 cellar: :any,                 x86_64_linux:  "feee0189517903b410e8811bbd2c9a7be5b740ac8816046dcfa75834eb45b18b"
  end

  depends_on "go" => :build

  def install
    ldflags = [
      "-s",
      "-w",
      "-X github.com/arimxyer/pass-cli/cmd.version=#{version}",
      "-X github.com/arimxyer/pass-cli/cmd.commit=homebrew",
      "-X github.com/arimxyer/pass-cli/cmd.date=unknown",
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:, output: bin/"pass-cli"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli version")

    init_cmd = [
      "HOME=#{testpath}",
      "PASS_CLI_TEST=1",
      bin/"pass-cli",
      "init",
      "--no-sync",
      "--no-recovery",
      "--no-audit",
      "--use-keychain=false",
      "2>&1",
    ].join(" ")
    output = pipe_output(init_cmd, "StrongPass1!\nStrongPass1!\n")
    assert_match "Initializing new password vault", output
    assert_path_exists testpath/".pass-cli"/"vault.enc"
  end
end
