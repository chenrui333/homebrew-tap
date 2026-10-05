class Scholar < Formula
  desc "Reference Manager in Go"
  homepage "https://github.com/cgxeiji/scholar"
  url "https://github.com/cgxeiji/scholar/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9c17246667f0d435dd8e1be63aedc605aa351d749ab865b8b8393e4b9268158f"
  license "MIT"
  head "https://github.com/cgxeiji/scholar.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b139f17caa687c5f4ae6f1a495a821f2839e5368a626904e11ee39f95f642ad3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b139f17caa687c5f4ae6f1a495a821f2839e5368a626904e11ee39f95f642ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b139f17caa687c5f4ae6f1a495a821f2839e5368a626904e11ee39f95f642ad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85665efcb8d0584484256a9f55e72e638dc3370174db24e66762a3d4894cbd72"
    sha256 cellar: :any,                 x86_64_linux:  "aee7419d214d01c23c0619d12493663606fea964d7f2a08ffd06e88ae057467a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # Pre-1.17 go.mod omits indirect deps the build needs; fetch the full module graph.
    system "go", "mod", "download", "all"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    (testpath/"refs.bib").write <<~BIB
      @article{einstein1905,
        author = {Albert Einstein},
        title = {On the Electrodynamics of Moving Bodies},
        date = {1905}
      }
    BIB

    assert_match "Import from refs.bib successful!", shell_output("#{bin}/scholar import refs.bib")
    assert_path_exists testpath/"ScholarLibrary/einstein1905/entry.yaml"

    output = shell_output("#{bin}/scholar export --format=ris")
    assert_match "TI  - On the Electrodynamics of Moving Bodies", output
    assert_match "AU  - Albert Einstein", output
  end
end
