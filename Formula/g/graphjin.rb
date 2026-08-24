class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.46.tar.gz"
  sha256 "4bc77cbf8acdfd87be1ea4fb4fb6a3ec7d16754d5949498429e9a034bc9b3828"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "167f8a3dc63b33cb654bc1bf204c5c2e58ebba05a0f722a73b01bc681044abd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "382e420dcff3e8b1aa3fab3dcf059dd61fb62725972322869e70b4c86f037eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "879f3abda6b4d81c967f89eb346f40535e4b194089d06b2eb33738ab8b4b71e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a05913a597e236104e73b4d9dcca3fee83aa9637d6ff4de49602ad6bc66b2f7"
    sha256 cellar: :any,                 x86_64_linux:  "572c7163286aafdb6ee342f5457147ea5d516da197314d3c287bef816e56e54c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
