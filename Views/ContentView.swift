//
//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @ObservedObject var mainViewModel: MainViewModel

    var body: some View {
        TabView {
            NavigationView {
                ZStack {
                    Color.black.ignoresSafeArea()

                    VStack {
                        Image("Haul-transport")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .offset(y: -100)

                        Text("Mission")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .offset(y: -80)

                        Text("""
                            At Haul Transport, we empower businesses by delivering fast and reliable packing and shipping solutions. Timely delivery fuels growth and sustainability, helping companies thrive and making a positive global impact. 
                            """)
                            .font(.callout)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .padding()
                            .offset(y: -40)

                        NavigationLink(destination: WhoWeAreView()) {
                    
                                Text("Who We Are")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                        }
                        .padding()
                        
                        
                        NavigationLink(destination: AboutView()) {
                    
                                Text("About")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                        }
                        .padding()
                        
                       
                        
                        
                        
                        

                        Button {
                            mainViewModel.signOut()
                        } label: {
                            Text("Sign out")
                                .padding()
                                .font(.headline)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
                .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            Serviceview()
                .tabItem {
                    Image(systemName: "truck.box")
                    Text("services")
                    
                }

            ProfileView(profileViewModel: mainViewModel)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
            
            
        }
    }
}

// Updated view name for clarity
struct WhoWeAreView: View {
    var body: some View {
        VStack {
            Text("Who We Are")
                .font(.largeTitle)
                .padding()

            Text("We are a logistics company committed to delivering exceptional transport solutions worldwide.")
                .padding()
        }
        .navigationTitle("Who We Are")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// Updated view name for clarity
struct AboutView: View {
    var body: some View {
        VStack {
            Text("About page")
                .font(.largeTitle)
                .padding()

            Text("At Haulway Transport, we go beyond offering eco-friendly trucks by providing customized fleet solutions tailored to your specific needs. This ensures our vehicles and logistics strategies align with your operational requirements, optimizing performance and reducing costs while enhancing sustainability. Our logistics management services utilize cutting-edge technology to efficiently manage routes, schedules, and resources, ensuring timely and budget-friendly deliveries. Real-time tracking allows you to monitor shipments and address issues promptly. We also offer sustainability consulting to help integrate eco-friendly practices into your logistics strategy, guiding you on reducing carbon footprints and improving energy efficiency. Partnering with us means choosing a transportation solution that not only meets your logistical needs but also supports environmental goals, contributing to a greener future.")
                .padding()
        }
        .navigationTitle("Who We Are")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Serviceview: View {
    var body: some View {
        Text("Service")
        ZStack {
                   // Full-screen background image
                   Image("try 1")
                       .resizable()
                       .scaledToFill()
                       .ignoresSafeArea()
                   
                   // Overlay to make text readable
                   Color.black.opacity(0.65)
                       .ignoresSafeArea()

                   ScrollView {
                       VStack(spacing: 30) {
                           // Logo
                           Image("Haul-transport")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 150)
                               .clipShape(RoundedRectangle(cornerRadius: 12))
                               .shadow(radius: 5)

                           // Title
                           Text("Haulway Transport")
                               .font(.custom("broncos", size: 34)) // Custom font if installed
                               .foregroundColor(.yellow)
                               .shadow(radius: 1)

                           // Section Title
                           Text("Our Services")
                               .font(.title2)
                               .foregroundColor(.yellow)
                               .bold()

                           VStack(alignment: .leading, spacing: 20) {
                               ServiceItem(title: "Tracking and Reporting", description: "Real-time tracking keeps you in the loop at all times.")
                               ServiceItem(title: "Customer Support & Reliability", description: "24/7 support ensures a smooth, reliable experience.")
                               ServiceItem(title: "Logistics Optimization", description: "Efficient routes save you time and money.")
                               ServiceItem(title: "Emergency Planning", description: "Quick response to unexpected delays.")
                               ServiceItem(title: "Customized Fleet Solutions", description: "Tailored logistics to suit your business.")
                           }

                           Text("Pricing Structure")
                               .font(.title3)
                               .foregroundColor(.yellow)
                               .padding(.top)

                           PricingTable()

                           Text("Additional Services")
                               .font(.title3)
                               .foregroundColor(.yellow)

                           VStack(alignment: .leading, spacing: 10) {
                               PricingItem(text: "Expedited Shipping: + $150")
                               PricingItem(text: "White-Glove Service: + $250")
                               PricingItem(text: "Storage & Handling: + $80/day")
                               PricingItem(text: "Hazardous Materials: + $400")
                           }
                           .padding(.horizontal)
                       }
                       .padding()
                       .frame(maxWidth: 600) // Keeps layout centered and readable
                   }
               }
           }
       }

       // MARK: - Components

       struct ServiceItem: View {
           let title: String
           let description: String

           var body: some View {
               VStack(alignment: .leading, spacing: 6) {
                   Text(title)
                       .font(.headline)
                       .foregroundColor(.yellow)
                   Text(description)
                       .font(.body)
                       .foregroundColor(.white)
               }
               .padding()
               .background(Color.black.opacity(0.4))
               .cornerRadius(10)
           }
       }

       struct PricingItem: View {
           let text: String

           var body: some View {
               Text("• \(text)")
                   .foregroundColor(.white)
                   .font(.body)
           }
       }

       struct PricingTable: View {
           var body: some View {
               VStack(spacing: 10) {
                   PricingRow(label: "1 - 50 miles (Local)", price: "$250" )
                   PricingRow(label: "51 - 100 miles (Short Haul)", price: "$500 ")
                   PricingRow(label: "101 - 200 miles (Medium Haul)", price: "$900")
                   PricingRow(label: "201 - 300 miles (Long Haul)", price: "$1,500")
                   PricingRow(label: "301+ miles", price: "$2,200 + $0.80/mi")
               }
               .padding()
               .background(Color.white.opacity(0.85))
               .cornerRadius(12)
           }
       }

       struct PricingRow: View {
           let label: String
           let price: String

           var body: some View {
               HStack {
                   Text(label)
                       .foregroundColor(.black)
                       .font(.subheadline)
                   Spacer()
                   Text(price)
                       .foregroundColor(.black)
                       .bold()
               }
               .padding(.horizontal)
           }
       }
        
    



// Profile View
struct ProfileView: View {
    @ObservedObject var profileViewModel: MainViewModel

    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            UserProfileView(mainViewModel: profileViewModel)
        }
    }
}

#Preview {
    ContentView(mainViewModel: MainViewModel())
}

