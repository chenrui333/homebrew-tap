class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "b39050456ead81037ae0b5a843a20dd18c72182005e86d3531353df867f19831"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ef906cd867f6d373a0100e487df76a5c9fc3b8860966880070f839209d0d4ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f4c66014ebe3bfe510527bdacb0fda1aed7495749622eb7625c3c35c668620b"
    sha256 cellar: :any_skip_relocation, ventura:       "ad202686e22e0bc9be11fa6631d723f3d989a4ae7a6057547caa9311f21ad810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0395e7765e874c5eec23b543696fe7b82bfc960efac12ef06943fd38b22f7410"
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
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
