class Excise < Formula
  desc "Surgical terminal storage navigator"
  homepage "https://github.com/findyourexit/excise"
  url "https://github.com/findyourexit/excise/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "33d3be97c33ce5cf9c89584131eae69f8bb3127c3a1ce2b83fbf97c8f413ee13"
  license "MIT"
  head "https://github.com/findyourexit/excise.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/excise --version")

    fixture = testpath/"fixture"
    (fixture/"nested").mkpath
    (fixture/"nested/file.txt").write("fixture data\n")
    report = testpath/"report.json"
    system bin/"excise", "--format", "json", "--output", report, fixture
    assert_path_exists report
    assert_match "file.txt", report.read
  end
end
