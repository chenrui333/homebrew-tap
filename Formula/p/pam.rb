class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.5.0-beta.tar.gz"
  sha256 "c50ee4ae5cd9fcc260818cd95b7e320ed4e70cb6fd32addcee36516ab1b383b1"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d02ef1af7d893c6dc0ca91aba3033b17166433c4222a0e29727f35b991a0822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a9f4328f7e92a64fe6cb77c92e1662207d952b9c3b6e3eb5c2932b433db4b23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a696784eb2c95f361df4731411839b5726b2cee6f5032f5330fb267f6a17912f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d44fa9d8fa67a41c2c09ffb1f6b5e6dbfbb738e6ca76fba613e4a9040929882"
    sha256 cellar: :any,                 x86_64_linux:  "a4e398ffe19220f682970d9d2d5808d9332a8dae3676fc3156e19e2fe196deeb"
  end

  depends_on "go" => :build

  def install
    # Upstream renamed the project from pam to squix; keep a pam shim for this tap formula name.
    system "go", "build", *std_go_args(output: bin/"squix", ldflags: "-s -w"), "./cmd/squix"
    bin.install_symlink "squix" => "pam"
  end

  test do
    output = shell_output("#{bin}/pam list connections")
    assert_match "No connections configured", output
    assert_equal shell_output("#{bin}/squix --version").strip, shell_output("#{bin}/pam --version").strip
  end
end
