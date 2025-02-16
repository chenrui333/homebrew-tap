# framework: cobra
class Gowall < Formula
  desc "Fetch GitHub user information and show like neofetch"
  homepage "https://github.com/Achno/gowall"
  url "https://github.com/Achno/gowall/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "31992b7895211310301ca169bcc98305a1971221aa5d718033be3a45512ca9a4"
  license "MIT"
  head "https://github.com/Achno/gowall.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d0fc03d62900eeaeefc878cc814681a883ba537fe11c17a64fd4dbb6d92196c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cac6262efd42fa86feb44960d32e28ddc5cfd5b84b372b06775b8c72a4bfb731"
    sha256 cellar: :any_skip_relocation, ventura:       "1e92d1615ef7a4e80c67ade61cbd5d562c98b15a22ffeca80e92393831576bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a92199b94937d2b99aca00138a4e8653f0ad3d4427ad33668608ca5c3eefdd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gowall", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowall --version")

    assert_match "arcdark", shell_output("#{bin}/gowall list")

    system bin/"gowall", "extract", test_fixtures("test.jpg")
  end
end
