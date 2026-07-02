class PassCli < Formula
  desc "Secure CLI password manager with local encrypted storage"
  homepage "https://github.com/ari1110/pass-cli"
  url "https://github.com/ari1110/pass-cli/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "f0ed42df77507fbad2c87f8cd2a6a3bc3084c4948e7422b80847372348c72509"
  license "Apache-2.0"
  head "https://github.com/ari1110/pass-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "430cc9756b5fa34ee2eb6407f9446112018d4db86b29654f107acb54bc4e11b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "430cc9756b5fa34ee2eb6407f9446112018d4db86b29654f107acb54bc4e11b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "430cc9756b5fa34ee2eb6407f9446112018d4db86b29654f107acb54bc4e11b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a73889f8ef4abedebb7a73a2bd62134e29ffcd093cbd6baaddfd757729365167"
    sha256 cellar: :any,                 x86_64_linux:  "16c37a6510791f1adf413712fd8851b34c27ac209e75d7097c3046d2695a8514"
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
