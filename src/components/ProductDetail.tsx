import { X, ShoppingCart, Package, Truck, Shield } from 'lucide-react';
import { Product } from '../lib/supabase';

interface ProductDetailProps {
  product: Product | null;
  isOpen: boolean;
  onClose: () => void;
  onAddToCart: (product: Product) => void;
}

export default function ProductDetail({ product, isOpen, onClose, onAddToCart }: ProductDetailProps) {
  if (!isOpen || !product) return null;

  return (
    <>
      <div
        className="fixed inset-0 bg-black bg-opacity-50 z-40 transition-opacity"
        onClick={onClose}
      />
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
        <div className="bg-white rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl">
          <div className="sticky top-0 bg-white border-b px-6 py-4 flex items-center justify-between">
            <h2 className="text-2xl font-bold text-gray-900">Product Details</h2>
            <button
              onClick={onClose}
              className="p-2 hover:bg-gray-100 rounded-full transition-colors"
            >
              <X className="h-6 w-6" />
            </button>
          </div>

          <div className="p-6">
            <div className="grid md:grid-cols-2 gap-8">
              <div className="relative">
                <img
                  src={product.image_url}
                  alt={product.name}
                  className="w-full h-96 object-cover rounded-xl"
                />
                {product.featured && (
                  <span className="absolute top-4 right-4 bg-blue-600 text-white text-sm font-semibold px-4 py-2 rounded-full">
                    Featured
                  </span>
                )}
              </div>

              <div>
                <h1 className="text-3xl font-bold text-gray-900 mb-4">
                  {product.name}
                </h1>
                <div className="mb-6">
                  <span className="text-4xl font-bold text-blue-600">
                    ${product.price.toFixed(2)}
                  </span>
                </div>

                <p className="text-gray-700 leading-relaxed mb-6">
                  {product.description}
                </p>

                <div className="bg-gray-50 rounded-lg p-4 mb-6">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-gray-700 font-medium">Availability:</span>
                    <span className={`font-semibold ${product.stock > 0 ? 'text-green-600' : 'text-red-600'}`}>
                      {product.stock > 0 ? `${product.stock} in stock` : 'Out of stock'}
                    </span>
                  </div>
                </div>

                <button
                  onClick={() => {
                    onAddToCart(product);
                    onClose();
                  }}
                  disabled={product.stock === 0}
                  className="w-full bg-blue-600 text-white py-4 rounded-lg font-semibold hover:bg-blue-700 transition-colors flex items-center justify-center space-x-2 mb-6 disabled:bg-gray-300 disabled:cursor-not-allowed"
                >
                  <ShoppingCart className="h-5 w-5" />
                  <span>Add to Cart</span>
                </button>

                <div className="space-y-3">
                  <div className="flex items-start space-x-3 text-gray-700">
                    <Package className="h-5 w-5 mt-0.5 text-blue-600" />
                    <div>
                      <p className="font-medium">Free Shipping</p>
                      <p className="text-sm text-gray-600">On orders over $50</p>
                    </div>
                  </div>
                  <div className="flex items-start space-x-3 text-gray-700">
                    <Truck className="h-5 w-5 mt-0.5 text-blue-600" />
                    <div>
                      <p className="font-medium">Fast Delivery</p>
                      <p className="text-sm text-gray-600">2-5 business days</p>
                    </div>
                  </div>
                  <div className="flex items-start space-x-3 text-gray-700">
                    <Shield className="h-5 w-5 mt-0.5 text-blue-600" />
                    <div>
                      <p className="font-medium">Secure Payment</p>
                      <p className="text-sm text-gray-600">100% secure transactions</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
