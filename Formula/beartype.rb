class Beartype < Formula
  include Language::Python::Virtualenv

  desc "Unbearably fast O(1) runtime type-checking in pure Python"
  homepage "https://github.com/beartype/beartype"
  url "https://files.pythonhosted.org/packages/ec/91/067ba8e805db88b8260308609959b5e124f01cebdb5346f147887a78dca0/beartype-0.13.1.tar.gz"
  sha256 "2903947a8a1eb6030264e30108aa72cb1a805cfc9050c0f4014c4aed3a17a00b"
  license "MIT"
  # Default branch is "main" not "master" (unbearably modern)
  head "https://github.com/beartype/beartype.git", branch: "main"

  bottle do
    root_url "https://github.com/beartype/homebrew-beartype/releases/download/beartype-0.13.0"
    sha256 cellar: :any_skip_relocation, monterey:     "9ca266035de4db8ef2526ba721fe45598edb1440e00f1bb52c8a83f9b3da7572"
    sha256 cellar: :any_skip_relocation, big_sur:      "6783f898634fcb21a64d5a3c8c23f9762917b8bd60bae468c82f9721b235c2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aaacc63274b7d062763052958c8cd5c689d26e6e32e1fb6f89269b0671977e45"
  end

  depends_on "python@3.11"

  def install
    # Based on name-that-hash
    # https://github.com/Homebrew/homebrew-core/blob/9652b75b2bbaf728f70c50b09cce39520c08321d/Formula/name-that-hash.rb
    virtualenv_install_with_resources

    xy = Language::Python.major_minor_version Formula["python@3.11"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-beartype.pth").write pth_contents
  end

  test do
    # Simple version number check
    system Formula["python@3.11"].opt_bin/"python3.11", "-c", <<~EOS
      import #{name}
      assert #{name}.__version__ == "#{version}"
    EOS
  end
end
