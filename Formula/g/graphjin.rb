class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.59.tar.gz"
  sha256 "18131a2bb903c20a9c376d8625bc182d2b916d7a8672d28093bd27417726f471"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b9f8cbac7935aedd1feda54b528a931ae8a356435441642761117084745fb29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e0ca7b2d6c43cc8fb917c5c828aa787e749cf6bccf2242924fde66e2c1c73cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a41821ecbee9e911e907612d4e15704a93410be63614a53f1415d67d17a393f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bdf3ead43985f32928991746981db0bf41a426a6999e930217156f0f23a637e"
    sha256 cellar: :any,                 x86_64_linux:  "6615222680b08992998d3b88db560ef077e2a588b5712341f5d369269356f7ae"
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
