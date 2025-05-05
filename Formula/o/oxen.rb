class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "893fd592142a9e94a38c96452e009ecafb9c1964e947bc444ebf4f147847a5e2"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a65b711f79ce8c0ea0f319d1dcbc08509e798f6b3e700932b09f0ba451a89d4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e6444703109725b6c6da940b58d1a274ab9f6a77fc904a33fc77beb52455d01"
    sha256 cellar: :any_skip_relocation, ventura:       "bea5a231fadefe6df4e996e1415dcc10f95bca24bb6c086454c24e39dbcf2d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982dc46d13504502c970293317d055aee71e9406a06756ddb36ed3015d779a33"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
