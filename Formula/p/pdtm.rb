class Pdtm < Formula
  desc "ProjectDiscovery's Open Source Tool Manager"
  homepage "https://github.com/projectdiscovery/pdtm"
  url "https://github.com/projectdiscovery/pdtm/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "3690cc1b3746b6bf1aff04e97b190aab28e835c9270c57555e5858553f103b6f"
  license "MIT"
  head "https://github.com/projectdiscovery/pdtm.git", branch: "main"

  depends_on "go" => :build

  # purego patch, upstream pr ref, https://github.com/projectdiscovery/pdtm/pull/410
  patch do
    url "https://github.com/projectdiscovery/pdtm/commit/12988f95d56daa502d049165ea577106251eade5.patch?full_index=1"
    sha256 "da8d35c9c44544b4937f9a081499b7a708fe615bde4dce970de5d46a62990c22"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pdtm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdtm -version 2>&1")
    assert_match "#{testpath}/.pdtm/go/bin", shell_output("#{bin}/pdtm -show-path")
  end
end
