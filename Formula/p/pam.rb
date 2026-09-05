class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.5.3-beta.tar.gz"
  sha256 "5670b1396441353e4655c752b2088bc67f0f4ff90364388b35b199dc1980878b"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "052f30165039e1cbd78e25046af8e6a15adafc5cbbf47ff4ccc5fbdd40c856ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "373addaa13e29a3a75569d17624c6b842fa279a1a21466325e391be8d2a9df89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b798f27c315f11f9579a1a039fdd7865b880bb8e84ecad4c885b7ed7d97c11a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8924686e1c990b628d3826eee7b8fa8c1594b9a3af0a4b21b4d7521de479b69"
    sha256 cellar: :any,                 x86_64_linux:  "1f9a08a13fde481d56cdf3ac400107e71de744380e41d06ef7cb236e936a5b63"
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
