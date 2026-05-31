class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "e32cf8cfa4f0f9450db399eb0c4f0391b911ae4fac7cdf8819073b25781e893c"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb5f075c4dd52b7975fa8dbf655e6cacdd7915c35850c6361c35444d22e0258d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bffd3e8f64fd1acf9156c13252f069dd0681f9ab4ef2035b647671629a2001b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b41ec7363bf2a2643f8b6e841d1b309b8bae7d314cb8c80928b89f63eab82b0"
    sha256 cellar: :any,                 arm64_linux:   "ff5357bdab00e9d78c15eaa72389b5bafea097100d1a4a2cd2852130c48ecf4a"
    sha256 cellar: :any,                 x86_64_linux:  "d85d274713d86a183c30bc24172462f5ba94707467a5513d76ee0381cbf08ea5"
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
