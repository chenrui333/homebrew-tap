class Osmar < Formula
  desc "CLI to explore OSM data"
  homepage "https://github.com/codesoap/osmar"
  url "https://github.com/codesoap/osmar/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "9753deb74a09a50f8ab55bedf76a1c70f2b70be30d9964a3b8ff385751f66312"
  license "MIT"
  head "https://github.com/codesoap/osmar.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82271fdbb9dba11ce2370772919e7eafca51b5f4eca8ad2bc83f21848a258116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17286bf68e44b34f3a8ada4b6c85bbd5ee0b94e2dc3572faac01fdc5abff7aa7"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d5874e9fbbbe6ad965dc9fae2f8e69f68a3e94f5d5f2d6dc24e3c7be50294c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bcf2ea4b001c224fdfb0906c0c1079951c766c0e9cff11e12f15c7ca28cc2d2"
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
