class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "c016fa33229c5be961d0dfe9ab23aede7404c184f59135f85f11af685c43d973"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b666ce24dd2fa24e19b5f2bdea432a3c3aa8a8d38bec41d9c0e531f875c3fe53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bb7af84b0d6940f796c0bb0fd96efaa9a624e6c4d815600348756f5ca132a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3665e5f4dd501a385dbfebea95e0ffa10ab6cbaf9cfeda452d4a1a25d2fb418d"
    sha256 cellar: :any,                 arm64_linux:   "5ea966eb4cb3c7774b9a44c42eb0e69322fdc00755c80c77e1fd5ee5417b8644"
    sha256 cellar: :any,                 x86_64_linux:  "dd5675a5d818038955bd67e2685e9af0c84da0c0a5af67ca77118bc951eab673"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
