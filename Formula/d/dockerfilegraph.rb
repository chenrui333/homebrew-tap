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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bea655fcd7df5eebab935f07b5c10843ecd7856428da5d7e42e41603938bb54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a4fb50dd87c18c40103dbd44d26e16506c9906529b17460220d0b048693d072"
    sha256 cellar: :any_skip_relocation, ventura:       "7f4ba5060ec65e587a1d46dc4075d229630c64d3956c2bfe9201b6c19e192289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6930308d6bab4659e14283b22ed7b770992cff11789e73815bc06f3377ca2a33"
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
      FROM alpine@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS base
      RUN echo "Hello, World!" > /hello.txt

      FROM base AS final
      COPY --from=base /hello.txt /hello.txt
    DOCKERFILE

    output = shell_output("#{bin}/dockerfilegraph --filename Dockerfile")
    assert_match "Successfully created Dockerfile.pdf", output
    assert_path_exists testpath/"Dockerfile.pdf"
  end
end
