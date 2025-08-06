class Sloop < Formula
  desc "Kubernetes History Visualization"
  homepage "https://github.com/salesforce/sloop"
  url "https://github.com/salesforce/sloop/archive/refs/tags/v1.2.tar.gz"
  sha256 "ff5b6e91ab56ab534dfa967fa560fd9c2c4a95e63c38c19d1574c4c37645dbd5"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-installsuffix", "cgo", "./pkg/sloop"
  end

  test do
    assert_match "Getting k8s context with user-defined config", shell_output("#{bin}/sloop 2>&1", 2)
    assert_path_exists testpath/"data/KEYREGISTRY"
    assert_path_exists testpath/"data/MANIFEST"
  end
end
