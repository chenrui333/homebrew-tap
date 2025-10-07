class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "bc6c797d1ff2723c06ef5e4e54ae71b78585226620bf9d9481472aea112c578b"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7e35bc0f5060b9f1335af94c1fe4a46a97761987aa66b6bf854348f1e9e6a52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9969c445a48f5ed04dca35bf65c74f8d8ed7bb19985ef953585ad7c9f0a0e08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3f488b0c2025b2ee3c5f3710f0c7a3cee99362195aaf70d77cb198ba8cae17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46e9f45c44f497d1f7ea3943986f409ad31be2a2cbbc17730d4e3e2320401409"
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
