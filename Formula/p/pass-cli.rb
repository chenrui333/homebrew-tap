class PassCli < Formula
  desc "Secure CLI password manager with local encrypted storage"
  homepage "https://github.com/ari1110/pass-cli"
  url "https://github.com/ari1110/pass-cli/archive/refs/tags/v0.17.21.tar.gz"
  sha256 "f6192fc62cbc2789289e444327af1071292d0d25fe7edb0d9e6517aaabc1d7a6"
  license "Apache-2.0"
  head "https://github.com/ari1110/pass-cli.git", branch: "main"

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
