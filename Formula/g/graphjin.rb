class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "5ce41bf9a6d0c95478b304bf0d446d1e48fcd88248b165939c8f66b266b6a4b9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d7499f7a0f70c1a3aad1ca71e0afc37709d30bc6d36f30c169807f34bdf93e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23d46b148e937d6bfa9777cabf483cb8d3b9f619644925ee5d765d4ee68cc4f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "864413fdf37d1a1fc4fb33532b8793d82427922f629cbec12341998ab1b3752c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c72385ce7b5cc433342e329d90afde2904eb6962a78fdb99aa1d6dc12876f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a60a050a8aec900e89e920e03e7298a3042319234d60bfa9403811d7420e55f9"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
