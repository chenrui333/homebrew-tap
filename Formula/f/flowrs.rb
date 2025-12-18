class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "d7c69521c0801750ac5c4e87cd65cab33cd758a9f42c157ca1bbe645bfa0f321"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "008d3cf6ad59589f00e2b373e8a253ae37566509ed1ee3370283e9fba0626e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb384f43ab6f9b4f38caab54c2178c3f6d1b7636a7619c6e4fa7b0e4ac43572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311f9b0e9ea6c448525841ed62fd79318976ffc358c394612452306e381d559a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6552644918130fdd663252a8c44e759f7947e084686fd233ba7fd6885647c543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62c193d6fe17a5fe7280b5a438d16aa1ec728f9126a8a7fca97522fde1da9d82"
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
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
