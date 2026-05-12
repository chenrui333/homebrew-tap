class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "26df9c4c48bbdfa8074e2340d85d555aaaa6215ceee0bab6bdba58b8804f2aea"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da17ef207bcd3ceb9d63759d35a65e5900d7486363bf047e9256a17f78053c32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bf5ccd4e7647031aea566462dc11aa4689af514d72df7ad2932f3ee76aa952f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75380ad4ea133b43db0f27ba9731021b797294dd0cc35480a145f612bb7e90a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85c18e011ed55e1c97eeff6138f66484e2bed9eafd8d18be99125e3d63a9365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20bb947635c77d6df5d9380ad7fa540fb045d29093a92ca85ddd11263bed9b31"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")

    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aube --version")
    assert_match "Usage", shell_output("#{bin}/aubr --help")
    assert_match "Usage", shell_output("#{bin}/aubx --help")

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
