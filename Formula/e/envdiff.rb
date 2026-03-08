class Envdiff < Formula
  desc "Tool to snapshot and diff environments"
  homepage "https://github.com/GBerghoff/envdiff"
  url "https://github.com/GBerghoff/envdiff/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "1d5b83553b2bf026cb17a813c1c9ff20626359ff171075905ebaf2fbfb50d8fc"
  license "MIT"
  head "https://github.com/GBerghoff/envdiff.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/envdiff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envdiff --version")

    system bin/"envdiff", "init"
    assert_path_exists testpath/"envdiff.yaml"

    system bin/"envdiff", "snapshot", "-o", "snapshot.json"
    assert_path_exists testpath/"snapshot.json"

    output = shell_output("#{bin}/envdiff render snapshot.json")
    assert_match "SYSTEM", output
    assert_match "RUNTIME", output
  end
end
