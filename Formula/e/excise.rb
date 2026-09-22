class Excise < Formula
  desc "Surgical terminal storage navigator"
  homepage "https://github.com/findyourexit/excise"
  url "https://github.com/findyourexit/excise/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "33d3be97c33ce5cf9c89584131eae69f8bb3127c3a1ce2b83fbf97c8f413ee13"
  license "MIT"
  head "https://github.com/findyourexit/excise.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "685613a26dac195e4fc682531dab530904b44c059d7ec3a4cafaefd5bb552839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b56f4b94627e71aa894a624f15a031955eaf43b8c69d791c86fa3b3462d5c7c"
    sha256 cellar: :any,                 arm64_linux:   "3f2ebdba34dc0ae3e3193ac298bd7bfbbb4d944f6e3fb3404dedfe4bb9b1439f"
    sha256 cellar: :any,                 x86_64_linux:  "b8e2ca1fd539c9ef534f2b260a83967c6de68c6891969ab6fe04f4ffe7c31cf6"
  end

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
