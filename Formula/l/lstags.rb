class Lstags < Formula
  desc "Explore Docker registries and manipulate Docker images"
  homepage "https://github.com/ivanilves/lstags"
  url "https://github.com/ivanilves/lstags/archive/refs/tags/v1.2.23.tar.gz"
  sha256 "43ecc6b925e85cb6656b0114cc1404611cb5a4c50e0eeda80bcf5727ebf8c187"
  license "Apache-2.0"
  head "https://github.com/ivanilves/lstags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e3ee62bd84d2c5eadb873a512eb00391e92a454c1faa260839c9a5b67efc0b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e3ee62bd84d2c5eadb873a512eb00391e92a454c1faa260839c9a5b67efc0b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67a81ff33aae10e7294d89219354f4fcc855580e9c0b9e115a8eac235f37193b"
    sha256 cellar: :any,                 x86_64_linux:  "a75601fe303e8ad6377b84da556556acdf6108eecf78c8e35027cd332587bd61"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    inreplace "version.go", "CURRENT", version.to_s
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lstags --version")

    (testpath/"lstags.yaml").write <<~YAML
      lstags:
        registries: []
    YAML
    output = shell_output("#{bin}/lstags -f lstags.yaml 2>&1", 1)
    assert_match "no repos could be loaded from: lstags.yaml", output

    output = shell_output("#{bin}/lstags -f lstags.yaml alpine 2>&1", 1)
    assert_match "Load repositories from YAML or from CLI args", output
  end
end
