class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "ec9cfd4a43f4b030f1579af4ad40774e8a56fe1214300f8ed72cdb0009866265"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "608ed6008b2f2e01c795bca49b84748d96883e9bb411b183ad2b761d5525febc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "608ed6008b2f2e01c795bca49b84748d96883e9bb411b183ad2b761d5525febc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "608ed6008b2f2e01c795bca49b84748d96883e9bb411b183ad2b761d5525febc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e95c335e8e33e962f394e1cf985dbae786bfd19d8bdb06cd6f8a391cb957b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accaadb68a31a68686ef718fa9d80fcdacbd667b45f8a1b204d4e7acb786f22e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/werf/trdl/client/pkg/trdl.Version=#{version}"
    cd "client" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/trdl"
    end
  end

  test do
    ENV["TRDL_DEBUG"] = "true"
    ENV["TRDL_HOME_DIR"] = testpath.to_s

    assert_match version.to_s, shell_output("#{bin}/trdl --help")
    output = shell_output("#{bin}/trdl list")
    assert_match "Name  URL  Default Channel", output
  end
end
