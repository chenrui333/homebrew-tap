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

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["OSMAR_PBF_FILE"] = "bremen-latest.osm.pbf"

    resource "test_osm_file" do
      url "https://download.geofabrik.de/europe/germany/bremen-latest.osm.pbf"
      sha256 "cf9d3835cd06f8040a84bcf107a6919a03bd30d766e568525a9f63cb86275ff9"
    end

    testpath.install resource("test_osm_file")
    assert_match "addr:city: Bremen", shell_output("#{bin}/osmar 53.076 8.807 50")
  end
end
