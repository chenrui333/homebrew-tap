class Osmar < Formula
  desc "CLI to explore OSM data"
  homepage "https://github.com/codesoap/osmar"
  url "https://github.com/codesoap/osmar/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "9753deb74a09a50f8ab55bedf76a1c70f2b70be30d9964a3b8ff385751f66312"
  license "MIT"
  head "https://github.com/codesoap/osmar.git", branch: "master"

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
