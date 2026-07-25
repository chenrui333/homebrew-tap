class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.19.2.tar.gz"
  sha256 "a83b3a40a0188145c68b071607ea237a32899ad4604ba622d354286d2bbd0f52"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef9aeeac382184b5d4c58de7917f36fc5da792703988bb55c8e223a18729dcea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d16e0feb7b5cbe6fbff48ce6462595261046b99998557cdb64ac1b4585949f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bda98f86add735654fcde73541bc48f1df2d63a5412d394059d02fba544fa1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f4c13098c78deb5a804789f17422237619e4ac227b6743077f851e80e8fdaf"
    sha256 cellar: :any,                 x86_64_linux:  "fed5e1c6400edaf5a5847b02d3205e155dc440b80d2aaa29b1a11572dc76b57c"
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
