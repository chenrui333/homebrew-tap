class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "984409a69f7385a9ec3738a460f3a23ff045503958b0c6ff36757d1bea599b07"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10f9a65336861a58dd7a5d2fffbf35a017fca65fbfbdaa6bcf13cacc241289e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbfcb1c792d68ba2076edddaf4385fc83ce7320c7a29717e5fda5a91d8f8fee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abed823d80d7fb181052430a4b1f5c754660636bd4ea79206091f4bad040c4f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f005bcd841679ce60f67b9defc89f29d2ad1b593615c41c2e4be81bdb75b65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3632cb1a50f457983bd44d42c2ba49fab03509f9fdc5d0efe005206d694b084"
  end

  depends_on "go" => :build

  def install
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
