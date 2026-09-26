class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.5.4-beta.tar.gz"
  sha256 "c6ab6840b3bc6c0ef3c6f50142e9e369ef1abae876107abfdc959fc1cb31e148"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ddf501accad602a37112ff8819352b941412e9b945081ef5286139385b202b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d76f5fa5b0608eae0f2c3eacf9a548fdd55872ccae37be6d55a79de3c53b559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b675ff7b980b680fbe11bb83fa5f3d699fd2fd36c2c471947b5d1dd13bbdd387"
    sha256 cellar: :any,                 x86_64_linux:  "9aceb289c0cd3625c8e3420c0cd2394241f4bfdf3e82ac631bd2dda8a45333f0"
  end

  depends_on "go" => :build

  def install
    # Upstream renamed the project from pam to squix; keep a pam shim for this tap formula name.
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"squix", ldflags:), "./cmd/squix"
    bin.install_symlink "squix" => "pam"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/squix --version")

    output = shell_output("#{bin}/pam list connections")
    assert_match "No connections configured", output
    assert_equal shell_output("#{bin}/squix --version").strip, shell_output("#{bin}/pam --version").strip
  end
end
