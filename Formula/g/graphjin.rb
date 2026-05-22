class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.23.tar.gz"
  sha256 "31ba06afba4c7e9b101dbb598913db566561676cbc58c5429069756f27ff5dc6"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fa5638a1d222aaf3365a144e988e9c41cbe38f9ae12604831b7b3cb49950f19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ae5c6a37b6dd5d0f0d33a2c766078b88555db30e6bbcd45e45b89c92bfe1eeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d00ccd9ac22a750eb8fba492f9293bff3e4126abed28ec07a5a992e44ee97b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "260b9e7de59f1d335f482491c2df915a84da12c8f5a5c8d365973aed6d5ad5bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac9b5a08d8509b29c78ae3232b77299fdfe57fcbb9d3d1cb7cadf5ceee6537b"
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
