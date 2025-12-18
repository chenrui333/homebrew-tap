class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "d7c69521c0801750ac5c4e87cd65cab33cd758a9f42c157ca1bbe645bfa0f321"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1294734f756bb2ed9f338459b428f41316107b77d0161b7b94880ede38c929e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4156b96ef0b93d02ddda64c6b14c6d5ca2bc8303d892a0b1aab0437d35ba7ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a665715363ee0d78d9267c59aea3dee10d58dfae5aafda5741a7013a79ce82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e11ce1a8c6831baac7459a32d38146f3e1f2b4beab798f064bd8ae5b878062e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "158b068993d22e90b4e92438a5f75cdf0b27d30c3f48fc403c7827bf735c2da1"
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
