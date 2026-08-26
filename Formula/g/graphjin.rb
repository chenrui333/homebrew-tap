class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.59.tar.gz"
  sha256 "18131a2bb903c20a9c376d8625bc182d2b916d7a8672d28093bd27417726f471"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73ac6bb5f03c1d73f862afbae0758e7e1783c6fb48dd8a35f93cab9d58af5fe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0eff6e300b20e25a664b8b1df18cca721771bc532f39a133eb812e5cdf41eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9417d08cdac28cc7aa7f3dc860fe9e455b26709ff63de009538bea5c8da3a4af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83e0c69f53c645fde35aa6282b57129a32a5b42ed00429ed142e1c3cfbb5ca5"
    sha256 cellar: :any,                 x86_64_linux:  "b2845055a4e322f319de744b42c6196799eb8b17dcd05e109b1c72a7f1d5fddb"
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
