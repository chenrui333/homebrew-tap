class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "cc1267903e89b653ff9d903f349cd73e9108c632b0e703bd1401b239ab95ff79"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd87d55b38e6cb1611a40a3f1d781d63fdb2309c94d839ed6ab6dc4af6a63cbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "855571b6ebf02c3dfab8684e1d079da745a64ca763543d7d63fc1d7bb58016b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1dbd91af4c796542eb16e03feaa634b923cdae3e4fdc236a420760ebf372219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e751c6ab9dd5837ce5ebc9dcaa463c3021f597a0ea471c9c31b8e64e1c28efb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a30def2dbeed20ded071f4970b62cc635d01b62a19fcc2f8e51125b864893152"
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
