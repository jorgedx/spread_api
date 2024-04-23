
# README
* API Documentation
  * https://www.notion.so/Markets-Spreads-Api-Buda-0808c5b09fbf4327927134a27b979cfd?pvs=4

* Docker Instructions
  * docker build -f dev.dockerfile -t spread_api .
  * docker run -p 3000:3000 spread_api

* Ruby version
  * Rails 7.1.3.2 
  * ruby 3.1.2-p20
  * Puma version: 6.4.2
    
-- Supuestos
- Se supone que solo se desea guardar una alerta por market.
- Se supone que la entrega del resultado de la alerta en el pooling sea de:
 *  1  : alerta mayor que spread calculado del mercado
 *  0  : alerta igual al spread calculado del mercado
 * -1 : alerta menor al spread calculado del mercado

