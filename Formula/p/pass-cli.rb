class PassCli < Formula
  desc "Secure CLI password manager with local encrypted storage"
  homepage "https://github.com/ari1110/pass-cli"
  url "https://github.com/ari1110/pass-cli/archive/refs/tags/v0.17.21.tar.gz"
  sha256 "f6192fc62cbc2789289e444327af1071292d0d25fe7edb0d9e6517aaabc1d7a6"
  license "Apache-2.0"
  head "https://github.com/ari1110/pass-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "419c5306d548525ef048090cd89c9c091b0a0a6fe6775610490dbc8fff27862b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "419c5306d548525ef048090cd89c9c091b0a0a6fe6775610490dbc8fff27862b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419c5306d548525ef048090cd89c9c091b0a0a6fe6775610490dbc8fff27862b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9320490be9df9e612ec654d64617a3d502c9690286acd227d6ec4a159a363a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ddd5f10875474155681dc1118b053328e2d12013c21fb9ac10ddfb57525778"
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
