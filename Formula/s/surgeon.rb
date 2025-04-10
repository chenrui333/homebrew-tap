# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "0573fa9371443495117e38dab3c3604cb35f7da31bf005fd43a826976f36ea8e"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "679ce477526991345e51861d78fda17f441cecc79445586f702c6897d03f615d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73418240c2ed05e844864a3f6f47ed9da14b6a2569c742d9ededa52cdac7f9f3"
    sha256 cellar: :any_skip_relocation, ventura:       "6f0de7168577370c8af5525f8d0cf6e04d088a2a73942422e7555ea49914476c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbcec8ab9698661d113464917c67197490622c04e0a51343a291eda3feefa522"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.treeState=clean
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/surgeon"

    generate_completions_from_executable(bin/"surgeon", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surgeon --version")

    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
