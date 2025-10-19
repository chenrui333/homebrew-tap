class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "a8a18b04278241f3e837c2eb0e618f9bfb51f86329d9cd3b3463151269f86ec6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "252b2bddb87766ea0391321cfb16fc8a885e6d75969d85b3ee4cff7daf2e6e11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b8e844c343f7fe98137bc246e104e7986c95c230262c9ca53a3d7fa4f75837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1df317ae52cb5ca6c168709f9e72d789842a006f19590f74144df3ff8de5ae98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "496e7b77797bb30352b06e75969a2623f490a6838d3894ceaaef64050b5fdb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48303b75efafd6980ab6a8c878cfefb60334b863ffdcbe6eb79d2c11b2c4360"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/ludo-technologies/pyscn/internal/version.Version=#{version}
      -X github.com/ludo-technologies/pyscn/internal/version.Commit=#{tap.user}
      -X github.com/ludo-technologies/pyscn/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pyscn"

    generate_completions_from_executable(bin/"pyscn", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyscn version")

    (testpath/"test.py").write <<~PY
      def add(a, b):
          return a + b

      print(add(2, 3))
    PY

    output = shell_output("#{bin}/pyscn analyze #{testpath}/test.py 2>&1")
    assert_match "Health Score: 98/100 (Grade: A)", output
  end
end
