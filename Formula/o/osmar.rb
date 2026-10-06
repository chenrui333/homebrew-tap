class Osmar < Formula
  desc "CLI to explore OSM data"
  homepage "https://github.com/codesoap/osmar"
  url "https://github.com/codesoap/osmar/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "9753deb74a09a50f8ab55bedf76a1c70f2b70be30d9964a3b8ff385751f66312"
  license "MIT"
  head "https://github.com/codesoap/osmar.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e3509549752e80819ead5b88208f63c626d4d03fde3b35a6566e66bd8c133f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e3509549752e80819ead5b88208f63c626d4d03fde3b35a6566e66bd8c133f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bcbf36e99237e04dc13e0b730987343365dc823cd578d6ddff2a15bf4420bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad949cc71a21dbc3aa5d35261af7351b36a55a7162f48087315d5fca8dadc491"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Querying needs a downloaded OSM extract; check the local argument and input validation instead.
    output = shell_output("#{bin}/osmar 53.076 8.807 50 2>&1", 1)
    assert_match "The OSMAR_PBF_FILE environment variable must be set.", output

    ENV["OSMAR_PBF_FILE"] = testpath/"missing.osm.pbf"
    assert_match "Usage: osmar <lat> <lon> <radius_meter>", shell_output("#{bin}/osmar 53.076 2>&1", 1)
    assert_match "Could not parse lat", shell_output("#{bin}/osmar north 8.807 50 2>&1", 1)
    assert_match "tag without value: amenity", shell_output("#{bin}/osmar 53.076 8.807 50 amenity 2>&1", 1)
    assert_match "Failed to query database", shell_output("#{bin}/osmar 53.076 8.807 50 2>&1", 1)
  end
end
