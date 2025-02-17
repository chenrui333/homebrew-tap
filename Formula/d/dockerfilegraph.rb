# framework: cobra
class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.17.10.tar.gz"
  sha256 "74f1f8d986149cd239d3fa4ecafc45f34076b1abaa3f6cb26d7eec52a6791c1a"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b0ec845b9eec1c871c6a2614d6d1de7f2ed18f70f81a69d1e65874d8d1404a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1134d713fa9648aab13dab95eba8fb374f00f3f2f24c7799d9f56a49b9a022"
    sha256 cellar: :any_skip_relocation, ventura:       "cbca71387c8734fad061e6ee6a9c59280c100bb81e6fa9924233a0e6082025ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae89f25e0fed813fd64cf41570cdfc3d969b37c32a2969543027c8baa0fa574b"
  end

  depends_on "go" => :build
  depends_on "graphviz"

  def install
    ldflags = %W[
      -s -w
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.gitVersion=#{version}
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.gitCommit=#{tap.user}
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfilegraph --version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS base
      RUN echo "Hello, World!" > /hello.txt

      FROM base AS final
      COPY --from=base /hello.txt /hello.txt
    DOCKERFILE

    output = shell_output("#{bin}/dockerfilegraph --filename Dockerfile")
    assert_match "Successfully created Dockerfile.pdf", output
    assert_path_exists testpath/"Dockerfile.pdf"
  end
end
