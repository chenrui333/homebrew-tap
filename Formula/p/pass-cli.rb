class PassCli < Formula
  desc "Secure CLI password manager with local encrypted storage"
  homepage "https://github.com/ari1110/pass-cli"
  url "https://github.com/ari1110/pass-cli/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "b52325e56cce83eaf4fea951272037a63ac6c5fc33ad0ad18538cd383ff3f224"
  license "Apache-2.0"
  head "https://github.com/ari1110/pass-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6f257f770040b0746a864e4534a47f96a3bc2670300c68c5b84aa56a227d8e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f257f770040b0746a864e4534a47f96a3bc2670300c68c5b84aa56a227d8e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecd43dffd7bc8bb0c0f4bd906e3596b3e6b83d67bee593de2cf3b73853863ed4"
    sha256 cellar: :any,                 x86_64_linux:  "bdb344dd46b843464021605446dce919c4761b28afcaf267fb9031297169c96e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
