class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "938efa562ef23f5a15117316e8ae05c94421e3b50275ccd5798a8c42d25bdd73"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25933fc6571420258c2a0dfac6ec86699d2385421298a2f905bf51f02c9421e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1caab2cdf0d618e087770ce26f2105bf04ad15c1631c9f4580e207d8a5932401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fec8f9a17f9a08915e035b57c102053bfca10e76ff4e03cadf408cd893e0bc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ea7bfee56924bbca67f6ecf37ba311eac03faaf630212842cb3a999c6de216"
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
