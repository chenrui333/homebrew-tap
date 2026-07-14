class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "55276254c9bb6c6c54899d44aa94e79aafb280d2ebd21f387d9baca27676201f"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "987a841b05fb121a266c9aad62fee7425f77870ac02bc6622f6f6ed75037ab90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "633553ce9f794290d8f69093038b9e8af12e19e819a5f2fce5eac3f544514dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f72cdaa4b6749c14b221384f6993175f916b655bb34b52719db9c8ae4aa2cd93"
    sha256 cellar: :any,                 arm64_linux:   "a0d6da428efe78574437320f45c5b1999453dcc586d06a9e79ab11943ca8e34f"
    sha256 cellar: :any,                 x86_64_linux:  "fed9dc3c4b90f9ca882c89d949c77cc8f9200792b321e0d3ea1bfb15c7aeaade"
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
